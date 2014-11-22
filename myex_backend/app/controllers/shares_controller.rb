#encoding: utf-8
require 'pry'
class SharesController < ApplicationController

  def share_score
    @member = Member.find_by_id(params[:member_id])
    @nickname = @member.nickname.to_s.empty? ? "无昵称" : @member.nickname
    @members = Member.where(true).order("score DESC")
    @percent = ((@members.count.to_f - @members.index(@member).to_f) / @members.count.to_f * 100).to_i
    @ranking = @members.index(@member) + 1
    @photo = Photo.where("member_id = ? AND category = ?", params[:member_id], true).first
  end

  def share_record
    @member = Member.find_by_id(params[:member_id])
    @nickname = @member.nickname.to_s.empty? ? "无昵称" : @member.nickname
    @records = Record.where(true).order("score DESC")
    @record = Record.where("id = ? AND member_id = ?", params[:record_id], params[:member_id]).first
    @percent = ((@records.count.to_f - @records.index(@record).to_f) / @records.count.to_f * 100).to_i
    @actions0 = Action.where("kind = ? AND record_id = ?", 0, params[:record_id])
    @actions1 = Action.where("kind = ? AND record_id = ?", 1, params[:record_id])
    @photo = Photo.where("member_id = ? AND category = ?", params[:member_id], true).first
  end

end
