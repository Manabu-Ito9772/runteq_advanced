class TagPolicy < TaxonomyPolicy
  def index?
    user.admin? || user.editor?
  end

  def edit?
    user.admin? || user.editor?
  end

  def update?
    user.admin? || user.editor?
  end

  def destroy?
    user.admin? || user.editor?
  end
end
