class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discount_items
  has_many :bulk_discounts, through: :bulk_discount_items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def self.total_discounted_revenue(invoice_id)
    joins(invoice_items: { item: :bulk_discount })
      .where(invoices: { id: invoice_id })
      .sum('invoice_items.quantity * (invoice_items.unit_price * (1 - COALESCE(bulk_discounts.percentage_discount, 0) / 100.0))')
  end

  def total_discounted_revenue
    invoice_items.joins(item: :bulk_discount)
                 .sum('CASE WHEN bulk_discounts.quantity_threshold <= invoice_items.quantity THEN invoice_items.quantity * (invoice_items.unit_price * (1 - COALESCE(bulk_discounts.percentage_discount, 0) / 100.0)) ELSE invoice_items.quantity * invoice_items.unit_price END')
  end
end
