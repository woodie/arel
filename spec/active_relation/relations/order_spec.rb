require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

module ActiveRelation
  describe Order do
    before do
      @relation1 = Table.new(:foo)
      @relation2 = Table.new(:bar)
      @attribute1 = @relation1[:id]
      @attribute2 = @relation2[:id]
    end

    describe '#qualify' do
      it "distributes over the relation and attributes" do
        Order.new(@relation1, @attribute1).qualify. \
          should == Order.new(@relation1.qualify, @attribute1.qualify)
      end
    end
  
    describe '#to_sql' do
      it "manufactures sql with an order clause" do
        Order.new(@relation1, @attribute1).to_sql.should be_like("""
          SELECT `foo`.`name`, `foo`.`id`
          FROM `foo`
          ORDER BY `foo`.`id`
        """)
      end
    end
  end
end
  