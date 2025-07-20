require 'rails_helper'
require 'test_prof/recipes/rspec/let_it_be'

RSpec.describe ApplicationController, type: :controller do
  controller do
    public :after_sign_in_path_for, :after_sign_out_path_for, :configure_permitted_parameters
  end

  describe '#after_sign_in_path_for' do
    let(:docente) { double('User', ocupacao: 'docente') }
    let(:dicente) { double('User', ocupacao: 'dicente') }
    let(:admin)   { double('User', ocupacao: 'admin') }
    let(:outro)   { double('User', ocupacao: 'outro') }

    {
      docente: :sigaa_importar_path,
      dicente: :root_path,
      admin:   :rails_admin_path,
      outro:   :root_path
    }.each do |user, path|
      it "redireciona #{user} para #{path}" do
        expect(subject.after_sign_in_path_for(send(user))).to eq send(path)
      end
    end
  end

  describe '#after_sign_out_path_for' do
    it 'sempre redireciona para root_path' do
      expect(subject.after_sign_out_path_for(nil)).to eq root_path
      expect(subject.after_sign_out_path_for(:user)).to eq root_path
    end
  end

  describe '#configure_permitted_parameters' do
    let(:sanitizer) { double('Devise::ParameterSanitizer') }
    before { allow(subject).to receive(:devise_parameter_sanitizer).and_return(sanitizer) }

    [:sign_up, :account_update].each do |action|
      it "permite atributos extras para #{action}" do
        expect(sanitizer).to receive(:permit).with(action, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
        allow(sanitizer).to receive(:permit).with(([:sign_up, :account_update] - [action]).first, any_args)
        subject.configure_permitted_parameters
      end
    end
  end
end
