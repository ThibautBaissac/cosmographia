import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ['text', 'message']

  copy() {
    navigator.clipboard.writeText(this.textTarget.textContent.trim())
      .then(() => {
        // Show the success message
        this.messageTarget.textContent = 'Copied!'
        this.messageTarget.classList.remove('d-none')

        // Hide the success message after 2 seconds
        setTimeout(() => {
          this.messageTarget.classList.add('d-none')
        }, 2000)
      })
      .catch((error) => {
        console.error('Failed to copy text: ', error)
      })
  }
}
