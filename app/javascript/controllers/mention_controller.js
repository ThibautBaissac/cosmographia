import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce"

export default class extends Controller {
  static targets = ["textarea", "dropdown", "loading"]
  static values = {
    url: String // e.g., /users/mention_autocomplete
  }

  connect() {
    this.isMentioning = false
    this.mentionStartIndex = null
    this.currentSelectionIndex = -1
    this.debouncedSearch = debounce(this.searchUsers.bind(this), 300)
    this.abortController = null
  }

  disconnect() {
    if (this.debouncedSearch.cancel) {
      this.debouncedSearch.cancel()
    }
    if (this.abortController) {
      this.abortController.abort()
    }
  }

  onInput(event) {
    const textarea = this.textareaTarget
    const cursorPosition = textarea.selectionStart
    const textValue = textarea.value

    const mentionSubstring = this.getMentionSubstring(textValue, cursorPosition)

    if (mentionSubstring !== null) {
      this.isMentioning = mentionSubstring !== ""
      if (this.isMentioning) {
        this.mentionStartIndex = cursorPosition - mentionSubstring.length - 1
        this.debouncedSearch(mentionSubstring)
        this.showDropdown()
      } else {
        this.hideDropdown()
      }
    } else {
      this.isMentioning = false
      this.hideDropdown()
    }
  }

  onKeyDown(event) {
    if (!this.isMentioning) return

    const items = Array.from(this.dropdownTarget.querySelectorAll(".mention-dropdown-item"))
    if (items.length === 0) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.currentSelectionIndex = (this.currentSelectionIndex + 1) % items.length
        this.highlightSelection(items)
        break
      case "ArrowUp":
        event.preventDefault()
        this.currentSelectionIndex = (this.currentSelectionIndex - 1 + items.length) % items.length
        this.highlightSelection(items)
        break
      case "Enter":
        event.preventDefault()
        if (this.currentSelectionIndex >= 0 && this.currentSelectionIndex < items.length) {
          const selectedUser = {
            id: items[this.currentSelectionIndex].dataset.userId,
            slug: items[this.currentSelectionIndex].dataset.slug
          }
          this.selectMention(selectedUser)
        }
        break
      case "Escape":
        this.isMentioning = false
        this.hideDropdown()
        break
      default:
        break
    }
  }

  getMentionSubstring(text, cursorPosition) {
    const beforeCursor = text.slice(0, cursorPosition)
    const mentionMatch = beforeCursor.match(/@([\w]*)$/)
    if (mentionMatch) {
      return mentionMatch[1]
    }
    return null
  }

  searchUsers(query) {
    this.loadingTarget.classList.remove("d-none")

    if (this.abortController) {
      this.abortController.abort()
    }
    this.abortController = new AbortController()
    const url = `${this.urlValue}?q=${encodeURIComponent(query)}`

    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

    fetch(url, {
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": csrfToken
      },
      signal: this.abortController.signal
    })
      .then((response) => response.json())
      .then((data) => {
        this.loadingTarget.classList.add("d-none")
        this.renderDropdown(data)
      })
      .catch((error) => {
        this.loadingTarget.classList.add("d-none")
        if (error.name !== 'AbortError') {
          console.error("Error fetching mention data:", error)
        }
      })
  }

  renderDropdown(users) {
    this.clearDropdown()
    users.forEach((user, index) => this.addDropdownItem(user, index))
    if (users.length > 0) {
      this.showDropdown()
      this.currentSelectionIndex = -1
    } else {
      this.hideDropdown()
    }
  }

  clearDropdown() {
    this.dropdownTarget.innerHTML = ""
  }

  addDropdownItem(user, index) {
    const item = document.createElement("div")
    item.classList.add("mention-dropdown-item")
    item.setAttribute("role", "option")
    item.setAttribute("id", `mention-option-${index}`)
    item.textContent = user.slug
    item.dataset.userId = user.id
    item.dataset.slug = user.slug

    item.addEventListener("mousedown", (e) => {
      e.preventDefault()
      this.selectMention(user)
    })

    this.dropdownTarget.appendChild(item)
  }

  highlightSelection(items) {
    items.forEach((item, index) => {
      if (index === this.currentSelectionIndex) {
        item.classList.add("highlighted")
        item.setAttribute("aria-selected", "true")
        item.scrollIntoView({ block: "nearest" })
      } else {
        item.classList.remove("highlighted")
        item.setAttribute("aria-selected", "false")
      }
    })
  }

  selectMention(user) {
    const textarea = this.textareaTarget
    const textValue = textarea.value
    const cursorPosition = textarea.selectionStart

    const beforeMention = textValue.substring(0, this.mentionStartIndex)
    const afterMention = textValue.substring(this.mentionStartIndex + 1 + (this.getMentionSubstring(textValue, cursorPosition) || "").length)
    const newText = `${beforeMention}@${user.slug} ` + afterMention

    textarea.value = newText

    const newCursorPosition = beforeMention.length + 1 + user.slug.length + 1
    textarea.setSelectionRange(newCursorPosition, newCursorPosition)
    textarea.focus()

    this.isMentioning = false
    this.hideDropdown()
  }

  showDropdown() {
    this.dropdownTarget.classList.remove("d-none")
  }

  hideDropdown() {
    this.dropdownTarget.classList.add("d-none")
  }
}
