Spree::OptionValue.class_eval do
  validates :color_hex_code, :length => { :is => 6 }
  validates :presentation, :uniqueness => { :scope => :option_type_id }
  validates :name, :uniqueness => { :scope => :option_type_id }
  attr_accessible :color_hex_code

  before_save :check_color_code
  before_validation :auto_assign_color_hex_code
  after_initialize :auto_assign_color_hex_code

  def sku
    self.presentation
  end

  def self.color_option_value_for(arr)
    arr.map do |e|
      Spree::OptionValue.where(:option_type_id => Spree::OptionType.find_by_name('color').id, :name => e)
    end.flatten
  end

  def self.size_option_value_for(arr)
    arr.map do |e|
      Spree::OptionValue.where(:option_type_id => Spree::OptionType.find_by_name('size').id, :name => e)
    end.flatten
  end

  private

  def auto_assign_color_hex_code
    self.color_hex_code = "ffffff" if Spree::OptionType.exists?(:id => option_type_id) && color_hex_code.blank?
  end

  def check_color_code
    if self.option_type_id == Spree::OptionType.find_by_name('color').id
      errors[:base] << ::I18n.t(:must_choose_color)
    end
  end
end
