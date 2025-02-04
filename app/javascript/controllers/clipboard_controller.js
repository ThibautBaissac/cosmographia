import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ['text', 'message']
  timeoutId = null // Reference to the timeout, so it can be cleared if needed

  async copy() {
    try {
      const textToCopy = this.textTarget.textContent.trim()
      await navigator.clipboard.writeText(textToCopy)
      this.showMessage('Copied!')
    } catch (error) {
      console.error('Failed to copy text: ', error)
    }
  }

  showMessage(message) {
    this.messageTarget.textContent = message
    this.messageTarget.classList.remove('d-none')

    // Clear any existing timeout to avoid conflicts
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }

    // Hide the message after 2 seconds
    this.timeoutId = setTimeout(() => {
      this.hideMessage()
    }, 2000)
  }

  hideMessage() {
    this.messageTarget.classList.add('d-none')
  }
}
