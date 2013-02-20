# encoding: utf-8
require "tripod/criteria/execution"

module Tripod

  # This module defines behaviour for criteria
  class Criteria

   include Tripod::CriteriaExecution

    # the resource class that this criteria is for.
    attr_accessor :resource_class

    attr_accessor :where_clauses
    attr_accessor :extra_clauses

    attr_accessor :limit_clause
    attr_accessor :order_clause
    attr_accessor :offset_clause

    def initialize(resource_class)
      self.resource_class = resource_class
      self.where_clauses = []
      self.extra_clauses = []

      if resource_class._RDF_TYPE
        self.where("?uri a <#{resource_class._RDF_TYPE.to_s}>")
      else
        self.where("?uri ?p ?o")
      end
    end

    # they're equal if they return the same query
    def ==(other)
      build_select_query == other.send(:build_select_query)
    end

    # Takes a string and adds a where clause to this criteria.
    # Returns a criteria object.
    # Note: the subject being returned by the query must be identified by ?uri
    # e.g. my_criteria.where("?uri a <http://my-type>")
    #
    # TODO: make it also take a hash?
    def where(sparql_snippet)
      where_clauses << sparql_snippet
      self
    end

    # takes a string and adds an extra clause to this criteria.
    # e.g. my_criteria.extras("LIMIT 10 OFFSET 20").extrass
    #
    # TODO: make it also take a hash?
    def extras(sparql_snippet)
      extra_clauses << sparql_snippet
      self
    end

    # replaces this criteria's limit clause
    def limit(the_limit)
      self.limit_clause = "LIMIT #{the_limit.to_s}"
      self
    end

    # replaces this criteria's offset clause
    def offset(the_offset)
      self.offset_clause = "OFFSET #{the_offset.to_s}"
      self
    end

    # replaces this criteria's order clause
    def order(param)
      self.order_clause = "ORDER BY #{param}"
      self
    end

  end
end
