# frozen_string_literal: true

# Exemplo de uso:
# include_examples 'atribui recurso', :turma, :show
RSpec.shared_examples 'atribui recurso' do |resource, template|
  it "atribui o recurso e renderiza #{template}" do
    expect(assigns(resource)).not_to be_nil
    expect(response).to render_template(template)
  end
end

# Exemplo de uso:
# include_examples 'atribui coleção', :turmas, :index
RSpec.shared_examples 'atribui coleção' do |collection, template|
  it "atribui a coleção e renderiza #{template}" do
    expect(assigns(collection)).not_to be_nil
    expect(response).to render_template(template)
  end
end
