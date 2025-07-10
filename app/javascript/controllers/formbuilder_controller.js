import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["questions", "formulario"]

  connect() {
    console.log("[Stimulus] formbuilder conectado");

    this.index = 0
    this.questionsTarget.innerHTML = ""

    // Lê o conteúdo do JSON embutido
    const jsonScript = document.getElementById("form-json-data")
    if (jsonScript) {
      try {
        const form = JSON.parse(jsonScript.textContent)
        if (form.perguntas && Array.isArray(form.perguntas)) {
          form.perguntas.forEach(pergunta => {
            this.addQuestionFromJson(pergunta)
          })
        }
      } catch (error) {
        console.error("Erro ao fazer parse do JSON do template:", error)
      }
    }

    this.updateHiddenInput()
  }

  disconnect() {
    window.removeEventListener("add-pergunta", this._handleAddPergunta)
  }

  addQuestionFromJson(pergunta) {
    const question = document.createElement("div")
    question.classList.add("card", "bg-base-100", "shadow", "p-4", "mb-4", "space-y-2")
    question.dataset.index = this.index

    const opcoesTexto = (pergunta.tipo === "unica" && pergunta.opcoes)
      ? pergunta.opcoes.join("\n")
      : ""

    question.innerHTML = `
    <div class="flex justify-between items-center">
      <label class="font-semibold">Texto da Pergunta</label>
      <button type="button" class="btn btn-sm btn-error" data-action="click->formbuilder#removeQuestion">Remover</button>
    </div>
    <input type="text" name="pergunta_${this.index}_texto" value="${pergunta.texto}" class="input input-bordered w-full" data-action="input->formbuilder#updateHiddenInput">

    <label class="font-semibold">Tipo de Resposta</label>
    <select name="pergunta_${this.index}_tipo" class="select select-bordered w-full" data-action="change->formbuilder#updateHiddenInput">
      <option value="texto" ${pergunta.tipo === "texto" ? "selected" : ""}>Texto</option>
      <option value="nota" ${pergunta.tipo === "nota" ? "selected" : ""}>Escala de 1 a 5</option>
      <option value="unica" ${pergunta.tipo === "unica" ? "selected" : ""}>Escolha uma opção</option>
    </select>

    <div data-type-options class="${pergunta.tipo === "unica" ? "" : "hidden"}">
      <label class="font-semibold">Opções (uma por linha)</label>
      <textarea class="textarea textarea-bordered w-full" data-action="input->formbuilder#updateHiddenInput">${opcoesTexto}</textarea>
    </div>
  `

    this.questionsTarget.appendChild(question)

    // Ativa o toggle das opções conforme o tipo
    const tipoSelect = question.querySelector("select")
    tipoSelect.addEventListener("change", () => {
      const optionsDiv = question.querySelector("[data-type-options]")
      optionsDiv.classList.toggle("hidden", tipoSelect.value !== "unica")
    })

    this.index++
    this.updateHiddenInput()
  }


  addQuestion(event) {
    event.preventDefault()

    const question = document.createElement("div")
    question.classList.add("card", "bg-base-100", "shadow", "p-4", "mb-4", "space-y-2")
    question.dataset.index = this.index

    question.innerHTML = `
      <div class="flex justify-between items-center">
        <label class="font-semibold">Texto da Pergunta</label>
        <button type="button" class="btn btn-sm btn-error" data-action="click->formbuilder#removeQuestion">Remover</button>
      </div>
      <input type="text" name="pergunta_${this.index}_texto" class="input input-bordered w-full" data-action="input->formbuilder#updateHiddenInput">

      <label class="font-semibold">Tipo de Resposta</label>
      <select name="pergunta_${this.index}_tipo" class="select select-bordered w-full" data-action="change->formbuilder#updateHiddenInput">
        <option value="texto">Texto</option>
        <option value="nota">Escala de 1 a 5</option>
        <option value="unica">Escolha uma opção</option>
      </select>

      <div data-type-options class="hidden">
        <label class="font-semibold">Opções (uma por linha)</label>
        <textarea class="textarea textarea-bordered w-full" data-action="input->formbuilder#updateHiddenInput"></textarea>
      </div>
    `

    this.questionsTarget.appendChild(question)

    // listener para mostrar campo de opções se necessário
    const tipoSelect = question.querySelector("select")
    tipoSelect.addEventListener("change", () => {
      const optionsDiv = question.querySelector("[data-type-options]")
      optionsDiv.classList.toggle("hidden", tipoSelect.value !== "unica")
    })

    this.index++
    this.updateHiddenInput()
  }

  removeQuestion(event) {
    event.preventDefault()
    event.currentTarget.closest("[data-index]").remove()
    this.updateHiddenInput()
  }

  updateHiddenInput() {
    const questions = []

    this.questionsTarget.querySelectorAll("[data-index]").forEach((el) => {
      const texto = el.querySelector("input[type=text]").value
      const tipo = el.querySelector("select").value
      const opcoesTextarea = el.querySelector("[data-type-options] textarea")
      const opcoes = tipo === "unica" && opcoesTextarea ? opcoesTextarea.value.split("\n").map(opt => opt.trim()).filter(Boolean) : null

      const pergunta = { texto, tipo }
      if (opcoes) pergunta.opcoes = opcoes

      questions.push(pergunta)
    })

    this.formularioTarget.value = JSON.stringify({ perguntas: questions }, null, 2)
  }
}
