class FamilyBondsController < ApplicationController
  def index
    
  end

  def new
    @family_bond = FamilyBond.new
  end

  def create
    @family_bond = FamilyBond.new family_bond_params
    @family_bond.family_member_one = current_user
    if @family_bond.save
      redirect_to family_bonds_path
    else
      render :new
    end
  end

  def destroy
    
  end

  private
    def family_bond_params
      params.require(:family_bond).permit(:family_member_two_id)
    end
end
