<<<<<<< HEAD
#Prodygia README
##Basic Info
- Rails Version: 4.0.0
- Ruby Version: ruby-2.0.0-p247
- Server Env: ubuntu 12.04.3 LTS (32bit)

##Set up DB
####we use `postgresql` as Database, you can choose 9.3.X version of postgresql

###set up
1. there's file named `config/database.example`, copy and rename it as `config/database.yml`, then set your own account. Remeber, please **DO NOT** commit the `database.yml` into git-repo
2. after set up the file, run `rake db:create` to create DB locally, that will generate `Prodygia_dev`, and `Prodygia_test` tables for you
3. run `rake db:migrate` to initialize the DB
4. *pending* (how to feed the DB with some data?)

##Work flow
as a developer for this project, please obey the work flow below:

1. checkout a new branch from `dev` to do your own tasks([PivotalTracker project site](https://www.pivotaltracker.com/n/projects/871623)). And please keep your locally `dev` branch posted, each time you want to checkout from it, `pull` it first
2. after you finish your job, `push` to github([site](https://github.com/Originate/oc-prodygia-rails)), and ask for a **pull request** to **dev** branch.
3. after sending the PR, you can click "finish" button in PT story
4. after someone else **review** your PR, then the project leader will merge the branch for you.
5. after the project leader merged your PR, and pushed to staging server, he will help you click "deviler" button in PT. Then waiting for **accept/reject**


Note: anytime there's conflict when you trying to merge `dev` to your working branch, you should ask the author to work together with you to solve the conflict

##Deployment Instruction

**migrate for category**:

```
rake db:migrate
comment out has_many :categories, through: :categorizations in app/models/concern/act_as_categoriable.rb
rake category:associate
comment back the has_many statement
```
=======
SimpleWeb
=========
>>>>>>> 44dd7002c52eec4cd41c366ae43811cec70530fe
