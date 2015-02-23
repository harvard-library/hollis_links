require 'test_helper'

class LinkListTest < ActiveSupport::TestCase
  test "imports an xlsx file" do
    filename = Dir.glob(File.join('test', 'data', '*.xlsx')).first
    excel = Roo::Excelx.new(filename)
    me = LinkList.import_xlsx(excel)
    assert_instance_of LinkList, me, "is not a linklist"
    assert me.save, "failed to save successfully"
  end

  test "imported xlsx does not convert numbers to floats" do
    excel = Roo::Excelx.new('test/data/HOLLIS_Links_001787337.xlsx')
    me = LinkList.import_xlsx(excel)
    assert_instance_of String, me.links.first.name
    assert_equal '1915', me.links.first.name, 'first link of this record should be 1915.'
  end

  test "imports a csv file" do
    filename = Dir.glob(File.join('test', 'data', '*.csv')).first
    me = LinkList.import_csv(CSV.read(filename))
    assert_instance_of LinkList, me, "is not a linklist"
    assert me.save, "failed to save successfully"
  end

  test "disallows creation of records with same ext_id_type:ext_id" do
    filename = Dir.glob(File.join('test', 'data', '*.csv')).first
    me = LinkList.import_csv(CSV.read(filename))
    thee = LinkList.import_csv(CSV.read(filename))
    assert me.save
    begin
      thee.save!
    rescue ActiveRecord::RecordInvalid => e
      assert_not thee.persisted?, "should not be able to save record"
    end
    assert thee.errors.has_key?(:ext_id), "should have an error on `ext_id`"
  end
end
