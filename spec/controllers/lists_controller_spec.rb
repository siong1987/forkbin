require 'spec_helper'

describe ListsController, "#index without authentication" do
  it "should return status 302" do
    server_response = get :index, format: :json
    server_response.status.should == 401
  end
end

describe ListsController, "#index with authentication" do
  login_user

  it "should return empty array" do
    pattern = []

    server_response = get :index, format: :json
    server_response.body.should match_json_expression(pattern)
  end
end

describe ListsController, "#create with authentication" do
  login_user

  it "should create a new list" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items: []
      }
    }

    server_response = post(:create, list: { name: "New List" }, format: :json)
    server_response.status.should == 201
    server_response.body.should match_json_expression(pattern)
  end
end

describe ListsController, "#fork with authentication" do
  login_user

  it "should not be able to fork a private list" do
    list = FactoryGirl.build(:list)
    list.user = @user
    list.save
    list.update_items([{name: "first item", checked: false}, {name: "second item", checked: false}])

    server_response = post(:fork, list_id: list.id, format: :json)
    server_response.status.should == 422
    server_response.body.should == "null"
  end

  it "should return the same fork if the user forks their own list" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: true,
        fork_count: 0,
        items: []
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.is_public = true
    list.save

    server_response = post(:fork, list_id: list.id, format: :json)
    server_response.status.should == 201
    server_response.body.should match_json_expression(pattern)
  end

  it "should be able to fork a public list" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: true,
        fork_count: 1,
        items: []
      }
    }

    list = FactoryGirl.build(:list)
    list.user = FactoryGirl.create(:user)
    list.is_public = true
    list.save

    server_response = post(:fork, list_id: list.id, format: :json)
    server_response.status.should == 201
    server_response.body.should match_json_expression(pattern)
  end
end

describe ListsController, "#show with authentication" do
  login_user

  it "should show a list" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items: []
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.save

    server_response = get(:show, id:  list.id, format: :json)
    server_response.status.should == 200
    server_response.body.should match_json_expression(pattern)
  end

  it "should not show a private list" do
    list = FactoryGirl.build(:list)
    list.user = FactoryGirl.create(:user)
    list.save

    server_response = get(:show, id:  list.id, format: :json)
    server_response.status.should == 422
  end

  it "should show a list with items" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items:  [
          {
            item: { name: "first item", checked: false }
          },
          {
            item: { name: "second item", checked: false }
          }
        ]
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.save
    list.update_items([{name: "first item", checked: false}, {name: "second item", checked: false}])

    server_response = get(:show, id:  list.id, format: :json)
    server_response.status.should == 200
    server_response.body.should match_json_expression(pattern)
  end
end

describe ListsController, "#update with authentication" do
  login_user

  it "should show a updated list" do
    pattern = {
      list: {
        id: String,
        name: "Updated List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items: []
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.save

    server_response = put(:update, id:  list.id, list: { name: "Updated List" }, format: :json)
    server_response.status.should == 200
    server_response.body.should match_json_expression(pattern)
  end
end

describe ListsController, "#destroy with authentication" do
  login_user

  it "should destroy an existing list" do
    list = FactoryGirl.build(:list)
    list.user = @user
    list.save

    server_response = delete(:destroy, id:  list.id, format: :json)
    server_response.status.should == 200
    server_response.body.should == "null"

    @user.reload
    @user.lists.length.should == 0
  end
end

describe ListsController, "#update_items with authentication" do
  login_user

  it "should add an item to a new list" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items: [
          {
            item: { name: "new item", checked: false }
          }
        ]
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.save

    server_response = put(:update_items, list_id:  list.id, items: {:"0" => {name: "new item", checked: false}}, format: :json)
    server_response.status.should == 200
    server_response.body.should match_json_expression(pattern)

    list.reload
    list.histories.last.action.should == History::NEW
  end

  it "should add an item to a list with existing items" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items: [
          {
            item: { name: "first item", checked: false }
          },
          {
            item: { name: "second item", checked: false }
          }
        ]
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.save
    list.update_items([{name: "first item", checked: false}])

    server_response = put(:update_items, list_id: list.id, items: {:"0" => {name: "first item", checked: false}, :"1" => {name: "second item", checked: false}}, format: :json)
    server_response.status.should == 200
    server_response.body.should match_json_expression(pattern)

    list.reload
    list.histories.last.action.should == History::ADD
  end


  it "should delete an item from a list with existing items" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items: [
          {
            item: { name: "first item", checked: false }
          }
        ]
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.save
    list.update_items([{name: "first item", checked: false}, {name: "second item", checked: false}])

    server_response = put(:update_items, list_id:  list.id, items: {:"0" => {name: "first item", checked: false}}, format: :json)
    server_response.status.should == 200
    server_response.body.should match_json_expression(pattern)

    list.reload
    list.histories.last.action.should == History::DELETE
  end

  it "should be able to reorder items on existing list" do
    pattern = {
      list: {
        id: String,
        name: "New List",
        user_id: String,
        is_public: false,
        fork_count: 0,
        items: [
          {
            item: { name: "first item", checked: false }
          },
          {
            item: { name: "second item", checked: false }
          }
        ]
      }
    }

    list = FactoryGirl.build(:list)
    list.user = @user
    list.save
    list.update_items([{name: "first item", checked: false}, {name: "second item", checked: false}])

    server_response = put(:update_items, list_id:  list.id, items: {:'0' => {name: "second item", checked: false}, :'1' => {name: "first item", checked: false}}, format: :json)
    server_response.status.should == 200
    server_response.body.should match_json_expression(pattern)

    list.reload
    list.histories.last.action.should == History::REORDER
  end
end
