Spree::ProductsController.class_eval do
  before_filter :load_search_filter

  def index
    @header_color = 'white'
    @has_top_banner = true

    @searcher = Spree::Config.searcher_class.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products
    respond_with(@products)
  end

  def show
    return unless @product

    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)

    # referer = request.env['HTTP_REFERER']
    # if referer
    #   begin
    #     referer_path = URI.parse(request.env['HTTP_REFERER']).path
    #     # Fix for #2249
    #   rescue URI::InvalidURIError
    #     # Do nothing
    #   else
    #     if referer_path && referer_path.match(/\/t\/(.*)/)
    #       @taxon = Taxon.find_by_permalink($1)
    #     end
    #   end
    # end

    @header_color = 'white'
    @has_top_banner = true
    respond_with(@product)
  end

  private
  def load_search_filter
    @filter_option_values = Spree::OptionValue.select('id, color_hex_code').map do |option_value|
      [option_value.color_hex_code, option_value.id]
    end
    @filter_taxon_values = Spree::Taxonomy.select('id, name').map do |taxon|
      [taxon.name, taxon.id]
    end
  end
end
