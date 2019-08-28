RSpec.describe Graphql::Paging do
  it "has a version number" do
    expect(Graphql::Paging::VERSION).not_to be nil
  end

  context "users" do
    query_string = <<-QL
      query ($per: Int, $page: Int){
        users(per: $per, page: $page) {
          pageInfo {
            totalCount
            currentPage
            totalPages
            per
          }
          nodes {
            id
          }
        }
      }
    QL

    it "return page_info" do
      result = Schema.execute(query_string, variables: { page: 1, per: 5 })
      page_info = result.dig("data", "users", "pageInfo")
      expect(page_info).not_to be_nil
      expect(page_info["totalCount"]).to eq 11
      expect(page_info["totalPages"]).to eq 3
      expect(page_info["currentPage"]).to eq 1
      expect(page_info["per"]).to eq 5
    end

    it 'return nodes' do
      result = Schema.execute(query_string, variables: { page: 1, per: 5 })
      nodes = result.dig("data", "users", "nodes")
      expect(nodes).not_to be_nil
      expect(nodes.size).to eq 5
      expect(nodes.map{ |n| n["id"] }).to eq ["0", "1", "2", "3", "4"]
    end
  end

  context "usersWithArgs" do
    query_string = <<-QL
      query ($per: Int, $page: Int, $evenId: Boolean){
        usersWithArgs(per: $per, page: $page, evenId: $evenId) {
          pageInfo {
            totalCount
            currentPage
            totalPages
            per
          }
          nodes {
            id
          }
        }
      }
    QL

    it "return page_info" do
      result = Schema.execute(query_string, variables: { page: 1, per: 5, evenId: true })
      page_info = result.dig("data", "usersWithArgs", "pageInfo")
      expect(page_info).not_to be_nil
      expect(page_info["totalCount"]).to eq 6
      expect(page_info["totalPages"]).to eq 2
      expect(page_info["currentPage"]).to eq 1
      expect(page_info["per"]).to eq 5
    end

    it 'return nodes' do
      result = Schema.execute(query_string, variables: { page: 1, per: 5, evenId: true })
      nodes = result.dig("data", "usersWithArgs", "nodes")
      expect(nodes).not_to be_nil
      expect(nodes.size).to eq 5
      expect(nodes.map{ |n| n["id"] }).to eq ["0", "2", "4", "6", "8"]
    end
  end

  context "usersCustomFields" do
    query_string = <<-QL
      query ($per: Int, $page: Int){
        usersCustomFields(per: $per, page: $page) {
          count
          pageInfo {
            totalCount
            currentPage
            totalPages
            per
          }
          nodes {
            id
          }
        }
      }
    QL


    it "return count" do
      result = Schema.execute(query_string, variables: { page: 1, per: 5 })
      expect(result["data"]["usersCustomFields"]["count"]).to eq 11
    end

    it "return page_info" do
      result = Schema.execute(query_string, variables: { page: 1, per: 5 })
      page_info = result.dig("data", "usersCustomFields", "pageInfo")
      expect(page_info).not_to be_nil
      expect(page_info["totalCount"]).to eq 11
      expect(page_info["totalPages"]).to eq 3
      expect(page_info["currentPage"]).to eq 1
      expect(page_info["per"]).to eq 5
    end

    it 'return nodes' do
      result = Schema.execute(query_string, variables: { page: 1, per: 5 })
      nodes = result.dig("data", "usersCustomFields", "nodes")
      expect(nodes).not_to be_nil
      expect(nodes.size).to eq 5
      expect(nodes.map{ |n| n["id"] }).to eq ["0", "1", "2", "3", "4"]
    end
  end
end
