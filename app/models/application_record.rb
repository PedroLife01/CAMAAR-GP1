##
# Classe base para todos os models da aplicação.
#
# Essa classe herda de +ActiveRecord::Base+ e serve como superclasse abstrata para
# todos os outros models. Define comportamentos comuns e configurações padrão.
#
# ==== Características
# - Abstrata: não possui tabela associada no banco de dados.
# - Convenção padrão em aplicações Rails modernas.
#
# ==== Uso
# Todos os models da aplicação devem herdar de +ApplicationRecord+ ao invés de diretamente de +ActiveRecord::Base+.
#
# ==== Exemplo
#   class User < ApplicationRecord
#     # código do model
#   end
#
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
