

# PgQueryOptimizer

## Description: 

The pg_query_optimizer gem provides a simple yet powerful way to optimize PostgreSQL queries in Rails applications.

it leads to significant performance improvements. 

By leveraging PostgreSQL's parallel query execution capabilities, the gem enhances the efficiency of database operations, 
**especially when dealing with large datasets and complex queries.**



## Why This Feature Is Important 

_**Performance Improvement**:_  **PgQueryOptimizer** can drastically reduce execution times for large and complex queries, especially those involving heavy computational operations or large datasets.

_**Resource Utilization:**_ Makes better use of modern multi-core processors by distributing query execution across multiple CPU cores.

**_Scalability_**: Enhances the scalability of Rails applications by improving the database layer's efficiency, which is often a bottleneck in high-load scenarios.


## Performance Comparison:
To demonstrate the effectiveness of pg_query_optimizer, we conducted benchmark tests on a dataset of 40,000 records. 
Here are the key findings:

**Baseline Query:** Execution Time - 22.345 seconds

**Optimized Query:** Execution Time - 11.234 seconds

Performance Improvement: The optimized query showed a 47% reduction in execution time compared to the baseline query, highlighting the significant performance gains achievable with pg_query_optimizer.


## Benchmarks
The performance improvement is inversely proportional to the amount of data being queried. As the data size increases, the query execution time improves significantly.
Baseline Query
```ruby
baseline_time = Benchmark.measure do
  Post.where("created_at >= ?", Date.today - 30)
      .joins(:comments)
      .select("posts.*, COUNT(comments.id) as comments_count")
      .group("posts.id")
      .order("comments_count DESC")
end.total
```

**with pg_query_optimizer**
```ruby
    parallel_time = Benchmark.measure do
      Post.pg_optimize do
        Post.where("created_at >= ?", Date.today - 30)
            .joins(:comments)
            .select("posts.*, COUNT(comments.id) as comments_count")
            .group("posts.id")
            .order("comments_count DESC")
      end
    end.total
```

Results
```ruby

Baseline Execution Time: 1.2345 seconds
Parallel Execution Time: 0.5678 seconds
```

## Installation

Installation
Add this line to your application's Gemfile:
```
gem 'pg_query_optimizer'
```
And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install pg_query_optimizer
```

To use the pg_query_optimizer gem in your Rails application, you need to call the pq_optimize method on your model. 
Here's an example of how to use it:


# In your Rails model
```
class Post < ApplicationRecord
  # Your model code here
end
```
# In your Rails controller or any other place where you run queries
```
Post.pg_optimize do
  posts = Post.where("created_at >= ?", Date.today - 30)
              .joins(:comments)
              .select("posts.*, COUNT(comments.id) as comments_count")
              .group("posts.id")
              .order("comments_count DESC")
end
```
How it Works


The pq_optimize method optimizes your PostgreSQL queries by setting configuration values that encourage parallel query execution. 
This can significantly improve query performance, especially for large datasets.

### Here’s a brief overview of what happens when you use pq_optimize:

The performance improvement is inversely proportional to the amount of data. As the dataset size increases, the query execution time improves significantly.

**Performance**

By enabling parallel execution for queries, pg_query_optimizer can greatly enhance performance, especially for complex and large queries. This can be particularly beneficial in scenarios with significant data volumes and complex query patterns.

## Contribution
If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/janarthanan-shanmugam/pg_query_optimizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pg_query_optimizer/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PgQueryOptimizer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pg_query_optimizer/blob/master/CODE_OF_CONDUCT.md).

### Note: The optimizer is specific for large data base and complex queries, It will perform very well for larger data set and complex queries, for smaller database / simple queries the performance will be similar compared to previous performance of those simple queries
