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
          @photo.time = params[:time]
          @photo.category = params[:category]
          @photo.coach_id = params[:coach_id]
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
            error!({"error" => "删除照片失败。", "status" => "f" }, 400)
          end
        end

        desc "Update an photo."
        post 'update' do
          @photo = Photo.find_by_id(params[:id])
          if @photo
            @photo.title = params[:title]
            @photo.image = params[:image]
            @photo.member_id = params[:member_id]
            @photo.time = params[:time]
            @photo.category = params[:category]
            @photo.coach_id = params[:coach_id]
            if @photo.save
              present [@photo, @photo.image.url]
            else
              error!({"error" => "更新照片失败。", "status" => "f" }, 400)
            end
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end

        desc "Get a member's all photos."
        post 'member_photos' do
          @photos = Photo.where("member_id = ?", params[:member_id])
        end

        desc "Get a member's all assessment_photos."
        post 'member_assessment_photos' do
          @photos = Photo.where("member_id = ? AND category = ?", params[:member_id], false)
        end

        desc "Get a photo."
        get ':id' do
          @photo = Photo.find_by_id(params[:id])
          if @photo
            present [@photo, @photo.image.url]
          else
            error!({"error" => "ID错误。", "status" => "f" }, 400)
          end
        end
        

      end
    end
  end
end