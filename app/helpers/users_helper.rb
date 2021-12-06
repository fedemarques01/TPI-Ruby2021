module UsersHelper

    def loggedUserHasRole?(role)
        current_user.role.name == role
    end

    def isLoggedUser?(user)
        current_user.id == user.id
    end
end
