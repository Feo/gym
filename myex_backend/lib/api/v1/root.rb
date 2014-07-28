module API
  module V1
    class Root < Grape::API
      mount API::V1::Coaches
      mount API::V1::Members
    end
  end
end