require "spec_helper"

describe Tripod::Criteria do

  let(:person_criteria) { Tripod::Criteria.new(Person) }

  let(:resource_criteria) { Tripod::Criteria.new(Resource) }

  describe "#initialize" do

    it "should set the resource class accessor" do
      person_criteria.resource_class.should == Person
    end

    it "should initialize the extra clauses to a blank array" do
      person_criteria.extra_clauses.should == []
    end

    context "with rdf_type set on the class" do
      it "should initialize the where clauses to include a type restriction" do
        person_criteria.where_clauses.should == ["?uri a <http://person>"]
      end
    end

    context "with no rdf_type set on the class" do
      it "should initialize the where clauses to ?uri ?p ?o" do
        resource_criteria.where_clauses.should == ["?uri ?p ?o"]
      end
    end
  end

  describe "#where" do

    it "should add the sparql snippet to the where clauses" do
      resource_criteria.where("blah")
      resource_criteria.where_clauses.should == ["?uri ?p ?o", "blah"]
    end

    it "should return an instance of Criteria" do
      resource_criteria.where("blah").class == Tripod::Criteria
    end

    it "should return an instance of Criteria with the where clauses added" do
      resource_criteria.where("blah").where_clauses.should == ["?uri ?p ?o", "blah"]
    end

  end

  describe "#extras" do

    it "should add the sparql snippet to the extra clauses" do
      resource_criteria.extras("bleh")
      resource_criteria.extra_clauses.should == ["bleh"]
    end

    it "should return an instance of Criteria" do
      resource_criteria.extras("bleh").class == Tripod::Criteria
    end

    it "should return an instance of Criteria with the extra clauses added" do
      resource_criteria.extras("bleh").extra_clauses.should == ["bleh"]
    end
  end

  describe "#limit" do
    it "calls extras with the right limit clause" do
      resource_criteria.limit(10)
      resource_criteria.limit_clause.should == "LIMIT 10"
    end

    context 'calling it twice' do
      it 'should overwrite the previous version' do
         resource_criteria.limit(10)
         resource_criteria.limit(20)
         resource_criteria.limit_clause.should == "LIMIT 20"
      end
    end
  end

  describe "#offset" do
    it "calls extras with the right limit clause" do
      resource_criteria.offset(10)
      resource_criteria.offset_clause.should == "OFFSET 10"
    end

    context 'calling it twice' do
      it 'should overwrite the previous version' do
         resource_criteria.offset(10)
         resource_criteria.offset(30)
         resource_criteria.offset_clause.should == "OFFSET 30"
      end
    end
  end

  describe "#order" do
    it "calls extras with the right limit clause" do
      resource_criteria.order("DESC(?label)")
      resource_criteria.order_clause.should == "ORDER BY DESC(?label)"
    end

    context 'calling it twice' do
      it 'should overwrite the previous version' do
         resource_criteria.order("DESC(?label)")
         resource_criteria.order("ASC(?label)")
         resource_criteria.order_clause.should == "ORDER BY ASC(?label)"
      end
    end
  end

end