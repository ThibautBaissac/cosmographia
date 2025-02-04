import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce"

export default class extends Controller {
  static targets = ["textarea", "dropdown", "loading"]
  static values = {
    url: String
  }

  connect() {
    this.isMentioning = false
    this.mentionStartIndex = null
    this.currentSelectionIndex = -1
    this.debouncedSearch = debounce(this.searchUsers.bind(this), 300)
    this.abortController = null

    // Cache the CSRF token so don't query the DOM on every request
    const meta = document.querySelector("meta[name='csrf-token']")
    this.csrfToken = meta && meta.getAttribute("content")
  }

  disconnect() {
    this.debouncedSearch.cancel?.()
    this.abortController?.abort()
  }

  onInput() {
    const textarea = this.textareaTarget
    const cursorPosition = textarea.selectionStart
    const textValue = textarea.value
    const mentionSubstring = this.getMentionSubstring(textValue, cursorPosition)

    // If there’s no mention trigger, reset and hide dropdown
    if (mentionSubstring === null) {
      this.isMentioning = false
      return this.hideDropdown()
    }

    // If the user is actively typing a mention
    this.isMentioning = mentionSubstring.length > 0
    if (this.isMentioning) {
      this.mentionStartIndex = cursorPosition - mentionSubstring.length - 1
      this.debouncedSearch(mentionSubstring)
      this.showDropdown()
    } else {
      this.hideDropdown()
    }
  }

  onKeyDown(event) {
    if (!this.isMentioning) return

    const items = Array.from(this.dropdownTarget.querySelectorAll(".mention-dropdown-item"))
    if (!items.length) return

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
        if (items[this.currentSelectionIndex]) {
          const { userId, slug } = items[this.currentSelectionIndex].dataset
          this.selectMention({ id: userId, slug })
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

  // Returns the substring after the last "@" if it matches a word; otherwise null.
  getMentionSubstring(text, cursorPosition) {
    const beforeCursor = text.slice(0, cursorPosition)
    const match = beforeCursor.match(/@(\w*)$/)
    return match ? match[1] : null
  }

  async searchUsers(query) {
    this.toggleLoading(true)

    // Abort any pending request before starting a new one.
    this.abortController?.abort()
    this.abortController = new AbortController()

    const url = `${this.urlValue}?q=${encodeURIComponent(query)}`
    try {
      const response = await fetch(url, {
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": this.csrfToken
        },
        signal: this.abortController.signal
      })
      const data = await response.json()
      this.renderDropdown(data)
    } catch (error) {
      if (error.name !== "AbortError") {
        console.error("Error fetching mention data:", error)
      }
      this.hideDropdown()
    } finally {
      this.toggleLoading(false)
    }
  }

  toggleLoading(isLoading) {
    this.loadingTarget.classList.toggle("d-none", !isLoading)
  }

  renderDropdown(users) {
    this.clearDropdown()
    if (users.length === 0) {
      return this.hideDropdown()
    }

    users.forEach((user, index) => this.addDropdownItem(user, index))
    this.showDropdown()
    // Reset selection index when new data arrives.
    this.currentSelectionIndex = -1
  }

  clearDropdown() {
    this.dropdownTarget.innerHTML = ""
  }

  addDropdownItem(user, index) {
    const item = document.createElement("div")
    item.className = "mention-dropdown-item"
    item.setAttribute("role", "option")
    item.id = `mention-option-${index}`
    item.textContent = user.slug
    item.dataset.userId = user.id
    item.dataset.slug = user.slug

    // Use mousedown so that the selection happens before the textarea loses focus.
    item.addEventListener("mousedown", (e) => {
      e.preventDefault()
      this.selectMention(user)
    })

    this.dropdownTarget.appendChild(item)
  }

  highlightSelection(items) {
    items.forEach((item, index) => {
      const isSelected = index === this.currentSelectionIndex
      item.classList.toggle("highlighted", isSelected)
      item.setAttribute("aria-selected", isSelected.toString())
      if (isSelected) item.scrollIntoView({ block: "nearest" })
    })
  }

  selectMention(user) {
    const textarea = this.textareaTarget
    const textValue = textarea.value
    const cursorPosition = textarea.selectionStart
    // Compute the substring that was typed (if any) after "@".
    const currentMention = this.getMentionSubstring(textValue, cursorPosition) || ""

    // Build the new text:
    //  - Before the "@" that started the mention.
    //  - Insert the complete mention.
    //  - Append the text after the mention.
    const beforeMention = textValue.substring(0, this.mentionStartIndex)
    const afterMention = textValue.substring(this.mentionStartIndex + 1 + currentMention.length)
    const newText = `${beforeMention}@${user.slug} ${afterMention}`

    textarea.value = newText

    // Set the cursor just after the inserted mention.
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
