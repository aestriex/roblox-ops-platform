import { Controller } from "@hotwired/stimulus"
import * as pdfjsLib from "pdfjs-dist"

export default class extends Controller {
  static targets = ["pages", "pageIndicator"]
  static values = { url: String, workerSrc: String }

  initialize() {
    pdfjsLib.GlobalWorkerOptions.workerSrc = this.workerSrcValue

    this.scale = 1.25
    this.currentPage = 1

    this.observer = new IntersectionObserver(this.handleIntersect.bind(this), {
      root: this.pagesTarget,
      threshold: 0.5,
    })
  }

  disconnect() {
    this.observer?.disconnect()
  }

  urlValueChanged(url) {
    if (!url) return

    this.load(url)
  }

  versionSelected(event) {
    this.urlValue = event.detail.value
  }

  async load(url) {
    this.currentPage = 1
    this.pageIndicatorTarget.textContent = "Loading…"

    this.pdf = await pdfjsLib.getDocument(url).promise
    this.pageIndicatorTarget.textContent = `Page 1 of ${this.pdf.numPages}`
    await this.renderAllPages()
  }

  async renderAllPages() {
    this.observer.disconnect()
    this.pagesTarget.innerHTML = ""

    for (let num = 1; num <= this.pdf.numPages; num++) {
      const canvas = document.createElement("canvas")
      canvas.dataset.pageNumber = num
      canvas.className = "shadow-sm mx-auto block"
      this.pagesTarget.appendChild(canvas)
      this.observer.observe(canvas)

      await this.renderPage(num, canvas)
    }
  }

  async renderPage(num, canvas) {
    const page = await this.pdf.getPage(num)
    const viewport = page.getViewport({ scale: this.scale })
    const context = canvas.getContext("2d")

    canvas.width = viewport.width
    canvas.height = viewport.height

    await page.render({ canvasContext: context, viewport }).promise
  }

  handleIntersect(entries) {
    const mostVisible = entries
      .filter((entry) => entry.isIntersecting)
      .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0]

    if (!mostVisible) return

    this.currentPage = Number(mostVisible.target.dataset.pageNumber)
    this.pageIndicatorTarget.textContent = `Page ${this.currentPage} of ${this.pdf.numPages}`
  }

  zoomIn() {
    this.scale = Math.min(this.scale + 0.25, 3)
    this.renderAllPages()
  }

  zoomOut() {
    this.scale = Math.max(this.scale - 0.25, 0.5)
    this.renderAllPages()
  }

  openInNewTab() {
    window.open(this.urlValue, "_blank")
  }

  download() {
    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("disposition", "attachment")

    const link = document.createElement("a")
    link.href = url.pathname + url.search
    document.body.appendChild(link)
    link.click()
    link.remove()
  }
}
