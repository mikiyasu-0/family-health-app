class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[show]

  def index
    @groups = current_user.groups
  end

  def show
    @members = @group.users 
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    ActiveRecord::Base.transaction do
      @group.save!

      @group.group_memberships.create!(
        user: current_user,
        role: :admin
      )
    end

    redirect_to groups_path, notice: "グループを作成しました"
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "グループを作成できませんでした"
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_group
    @group = current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
