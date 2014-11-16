module API
  module V1
    class Root < Grape::API
      mount API::V1::Coaches
      mount API::V1::Members
      mount API::V1::Memberhabits
      mount API::V1::Events
      mount API::V1::Messages
      mount API::V1::Assessments
      mount API::V1::Records
      mount API::V1::Photos
      mount API::V1::Notices
    end
  end
end