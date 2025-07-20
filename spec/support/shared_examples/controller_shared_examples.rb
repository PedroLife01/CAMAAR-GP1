# frozen_string_literal: true

RSpec.shared_examples 'controller index render' do |resource, template|
  it 'atribui a coleção e renderiza index' do
    expect(assigns(resource)).not_to be_nil
    expect(response).to render_template(template)
  end
end

RSpec.shared_examples 'controller show render' do |resource, template|
  it 'atribui o recurso e renderiza show' do
    expect(assigns(resource)).not_to be_nil
    expect(response).to render_template(template)
  end
end

RSpec.shared_examples 'controller new render' do |resource, template|
  it 'atribui novo recurso e renderiza new' do
    expect(assigns(resource)).to be_a_new(Object.const_get(resource.to_s.classify))
    expect(response).to render_template(template)
  end
end

RSpec.shared_examples 'controller edit render' do |resource, template|
  it 'atribui o recurso e renderiza edit' do
    expect(assigns(resource)).not_to be_nil
    expect(response).to render_template(template)
  end
end
