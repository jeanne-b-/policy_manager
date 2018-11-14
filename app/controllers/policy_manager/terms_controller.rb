module PolicyManager
  class TermsController < ApplicationController
    def index
       @terms = Term.all
    end
  end
end
