class Insurance

  def delete_insurance(name)
     DB.exec("DELETE FROM insurance_companies WHERE name = '#{name}'")
  end
end
