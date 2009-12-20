class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest

    if user.is_admin?
      # CRUD everything
      can :manage, :all
      can :remove_all_spam, Story
      can [:spam, :ham], Comment
      can :vote, :all
    else
      # guest, normal user
      can :read, :all
      if user.id
        # normal user only
        # comment
        can :create, Comment
        can :update, Comment do |comment|
          comment.try(:user) == user
        end
        # story
        can :create, Story
        can :update, Story do |story|
          story.try(:user) == user
        end
        can [:create, :update, :destroy], Chapter do |chapter|
          chapter.story.user == user
        # page
        end
        can [:create, :update, :destroy], Page do |page|
          page.chapter.story.user == user
        end
        # voting
        can :vote, :all
      end
    end
  end
end
