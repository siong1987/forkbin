attributes :id, :name, :user_id, :is_public

child items: :items do
  node(:name) { |i| i.k }
  node(:checked) { |i| i.v }
end

node(:fork_count) do |l|
  l.parent.fork_count
end
