require 'pagy'
require 'pagy/extras/overflow'   # para lidar com overflow

Pagy::DEFAULT[:items]    = 10
Pagy::DEFAULT[:size]     = 7
Pagy::DEFAULT[:overflow] = :last_page
