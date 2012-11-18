collection @lists
attributes :id, :name, :is_public

node(:username) do |l|
  l.user.username
end

node(:fork_count) do |l|
  l.parent.fork_count
end
