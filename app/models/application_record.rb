##
# Classe base para todos os models da aplicação.
#
# Herda de +ActiveRecord::Base+ e define comportamentos compartilhados por todos os models.
# Essa classe é abstrata e não possui tabela associada no banco de dados.
#
# Todos os models devem herdar de +ApplicationRecord+.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end