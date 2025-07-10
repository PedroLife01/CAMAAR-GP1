module PagyHelper
  include Pagy::Frontend

  def pagy_nav_tailwind(pagy, link_extra: '')
    html = +''

    html << '<nav class="flex justify-center mt-4">'
    html << '<ul class="inline-flex items-center -space-x-px">'

    pagy.pages.times do |i|
      page = i + 1
      if page == pagy.page
        html << %(
          <li>
            <span class="px-3 py-2 leading-tight text-white bg-blue-600 border border-blue-600 rounded-md">
              #{page}
            </span>
          </li>
        )
      else
        html << %(
          <li>
            <a href="#{pagy_url_for(pagy,page)}" #{link_extra}
               class="px-3 py-2 leading-tight text-gray-700 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700">
              #{page}
            </a>
          </li>
        )
      end
    end

    html << '</ul>'
    html << '</nav>'
    html.html_safe
  end
end
