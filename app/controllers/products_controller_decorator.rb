Spree::ProductsController.class_eval do

  def index
  	@header_color = 'white'

    @searcher = Spree::Config.searcher_class.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products
    respond_with(@products)
  end
end
