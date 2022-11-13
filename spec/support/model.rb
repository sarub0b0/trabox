def create_spec_table(name, scope = :all, &block)
  before(scope) do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table name, &block
  end

  after(scope) do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.drop_table name
  end
end
