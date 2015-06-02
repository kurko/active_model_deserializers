# Active Model Deserializers

This is just a draft of a lib to receive data from clients following
JSONAPI.org.

# Usage

```ruby
def user_params
  ActiveModel::Deserializer
    .new(params)
    .require(:users)
    .permit(:id, :first_name, :last_name)
    .associations(:post, :comments)
end
```

This will load associations under `links` (as stated by the JSONAPI.org
standard).
