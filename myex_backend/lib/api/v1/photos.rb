#encoding: utf-8

module API
  module V1
    class Photos < Grape::API
      version 'v1'
      format :json

      resource :photos do

        before do
          authenticate!
        end

        desc "Upload a new photo."
        post 'upload' do
          @photo = Photo.new
          @photo.title = params[:title]
          @photo.image = params[:image]
          @photo.member_id = params[:member_id]
          if @photo.save
            present [@photo, @photo.image.url]
          else
            error!({"error" => "上传照片失败。", "status" => "f" }, 400)
          end
        end

        desc "Delete a photo."
        post 'delete' do
          @photo = Photo.find_by_id(params[:id])
          if @photo
            @photo.destroy
            present [@photo, @photo.image.url]
          else
            error!({"error" => "删除消息失败。", "status" => "f" }, 400)
          end
        end
        

      end
    end
  end
end