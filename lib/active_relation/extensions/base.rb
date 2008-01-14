class ActiveRecord::Base
  class << self
    def cache
      @identity_map ||= IdentityMap.new
    end
    
    def relation
      @relation ||= ActiveRelation::Table.new(table_name)
    end
  end
  
  class IdentityMap
    def initialize
      @map = {}
    end
    
    def get(record, &block)
      @map[record] ||= yield
    end
  end
end

# all of the below disables normal AR behavior. It's rather destructive and purely for demonstration purposes (see scratch_spec).
class ActiveRecord::Associations::BelongsToAssociation
  def instantiate(record, joins = [])
    @target = proxy_reflection.klass.instantiate(record, joins)
    loaded
  end
 
  # this basically disables belongs_to from loading themselves
  def reload
    @target = 'hack'
  end
end

class ActiveRecord::Associations::AssociationCollection
  def instantiate(record, joins = [])
    @target << proxy_reflection.klass.instantiate(record, joins)
    loaded # technically, this isn't true. doesn't matter though
  end
end

class ActiveRecord::Associations::HasManyThroughAssociation
  def instantiate(record, joins = [])
    @target << proxy_reflection.klass.instantiate(record, joins)
    loaded # again, not really true.
  end
end