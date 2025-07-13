require 'rails_helper'

RSpec.describe Formulario, type: :model do
  describe 'associations' do
    it { should belong_to(:template).with_foreign_key(:id_template) }
    it { should belong_to(:turma).with_foreign_key(:id_turma) }
    it { should belong_to(:docente).class_name('User').with_foreign_key(:id_docente) }
    it { should have_many(:controle_de_envios).dependent(:destroy) }
    it { should have_many(:respostas).dependent(:destroy) }
  end
end
