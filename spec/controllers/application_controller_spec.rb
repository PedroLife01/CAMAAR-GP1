require 'rails_helper'




RSpec.describe ApplicationController, type: :controller do
  controller do
    def test_sign_in_path
      user = params[:user]
      render plain: after_sign_in_path_for(user)
    end
    def test_sign_out_path
      render plain: after_sign_out_path_for(nil)
    end
    def test_configure_params
      configure_permitted_parameters
      render plain: 'ok'
    end
  end

  before(:all) do
    Rails.application.routes.draw do
      get 'test_sign_in_path' => 'anonymous#test_sign_in_path'
      get 'test_sign_out_path' => 'anonymous#test_sign_out_path'
      get 'test_configure_params' => 'anonymous#test_configure_params'
      get 'sigaa_importar' => 'home#index', as: :sigaa_importar
      get 'rails_admin' => 'home#index', as: :rails_admin
      root to: 'home#index'
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end


  describe '#after_sign_in_path_for' do
    let(:docente) { double('User', ocupacao: 'docente') }
    let(:dicente) { double('User', ocupacao: 'dicente') }
    let(:admin)   { double('User', ocupacao: 'admin') }
    let(:outro)   { double('User', ocupacao: 'outro') }

    before do
      allow(controller).to receive(:sigaa_importar_path).and_return('/sigaa_importar')
      allow(controller).to receive(:root_path).and_return('/')
      allow(controller).to receive(:rails_admin_path).and_return('/rails_admin')
    end

    it 'redireciona docente para sigaa_importar_path' do
      expect(controller.send(:after_sign_in_path_for, docente)).to eq('/sigaa_importar')
    end
    it 'redireciona dicente para root_path' do
      expect(controller.send(:after_sign_in_path_for, dicente)).to eq('/')
    end
    it 'redireciona admin para rails_admin_path' do
      expect(controller.send(:after_sign_in_path_for, admin)).to eq('/rails_admin')
    end
    it 'redireciona outros para root_path' do
      expect(controller.send(:after_sign_in_path_for, outro)).to eq('/')
    end
  end


  describe '#after_sign_out_path_for' do
    before { allow(controller).to receive(:root_path).and_return('/') }
    it 'sempre redireciona para root_path' do
      expect(controller.send(:after_sign_out_path_for, nil)).to eq('/')
    end
  end

  describe '#configure_permitted_parameters' do
    it 'permite atributos extras para sign_up e account_update' do
      sanitizer = double('Devise::ParameterSanitizer')
      expect(sanitizer).to receive(:permit).with(:sign_up, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
      expect(sanitizer).to receive(:permit).with(:account_update, keys: [:nome, :ocupacao, :usuario, :curso, :formacao, :matricula])
      allow(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)
      controller.send(:configure_permitted_parameters)
    end
  end
end
