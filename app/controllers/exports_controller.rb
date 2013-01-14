# -*r coding: utf-8 -*-
class ExportsController < ApplicationController
  def index
    raise if !current_user
  end
end
