# features/step_definitions/atualizar_sigaa_steps.rb

Given('o serviço do SIGAA está fora do ar') do
  stub_request(:get, "api.sigaa.com.br/dados").to_return(status: 503)
  puts "Atenção: O mock para 'serviço fora do ar' precisa ser implementado."
end

Then('o job {string} deve ter sido enfileirado') do |job_name|
  expect(job_name.constantize).to have_been_enqueued
end

Then('nenhum job deve ser enfileirado') do
  expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to be_empty
end