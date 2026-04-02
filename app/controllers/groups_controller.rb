class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path, notice: "グループを作成しました"
    else
      flash.now[:alert] = "グループを作成できませんでした"
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
