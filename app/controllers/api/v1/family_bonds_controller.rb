module Api
  module V1
    class FamilyBondsController < Api::BaseController
      # GET /api/v1/family_bonds
      def index
        @family_bonds = FamilyBond.all
      end

      # POST /api/v1/family_bonds
      def create
        @family_bond = FamilyBond.new family_bond_params
        @family_bond.family_member_one = current_user

        render json: {message: @family_bond.errors.full_messages}, 
          status: :unprocessable_entity and return if not @family_bond.save
      end

      # DELETE /api/v1/family_bonds/:id
      def destroy
        @family_bond = FamilyBond.find(params[:id])

        render json: {message: @family_bond.errors.full_messages}, 
          status: :unprocessable_entity and return if not @family_bond.destroy
      end

      private
        def family_bond_params
          params.require(:family_bond).permit(:family_member_two_id)
        end

    end # FamilyBondsController 
  end # V1
end # Api

