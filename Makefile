# type 'make -s list' to see list of targets.

checkout-project:
	git checkout develop
	git submodule update --init --recursive
	make setup-git

setup-project:
	make checkout-project
	cd presentation && make setup-app
	cd presentation-stubulator && make setup-app
	cd core && make setup-app
	cd core-stubulator && make setup-app

setup-git:
	git remote rm origin && git remote add origin git@github-thyms.com:thyms/anbu.git && git fetch && git checkout develop
	cd presentation && git remote rm origin && git remote add origin git@github-thyms.com:thyms/anbu-presentation.git && git fetch && git checkout develop
	cd presentation-functional && git remote rm origin && git remote add origin git@github-thyms.com:thyms/anbu-presentation-functional.git && git fetch && git checkout develop
	cd presentation-stubulator && git remote rm origin && git remote add origin git@github-thyms.com:thyms/anbu-presentation-stubulator.git && git fetch && git checkout develop
	cd core && git remote rm origin && git remote add origin git@github-thyms.com:thyms/anbu-core.git && git fetch && git checkout develop
	cd core-functional && git remote rm origin && git remote add origin git@github-thyms.com:thyms/anbu-core-functional.git && git fetch && git checkout develop
	cd core-stubulator && git remote rm origin && git remote add origin git@github-thyms.com:thyms/anbu-core-stubulator.git && git fetch && git checkout develop

setup-heroku:
	heroku apps:create --remote func01       --app anbu-presentation-func01
	heroku apps:create --remote qa01         --app anbu-presentation-qa01
	heroku apps:create --remote demo01       --app anbu-presentation-demo01
	heroku apps:create --remote stage01      --app anbu-presentation-stage01
	heroku apps:create --remote prod01       --app anbu-presentation-prod01
	heroku apps:create --remote stub01       --app anbu-presentation-stub01
	heroku apps:create --remote func01       --app anbu-core-func01
	heroku apps:create --remote qa01         --app anbu-core-qa01
	heroku apps:create --remote demo01       --app anbu-core-demo01
	heroku apps:create --remote stage01      --app anbu-core-stage01
	heroku apps:create --remote prod01       --app anbu-core-prod01
	heroku apps:create --remote stub01       --app anbu-core-stub01
	heroku config:add NODE_ENV=func01        --app anbu-presentation-func01
	heroku config:add NODE_ENV=qa01          --app anbu-presentation-qa01
	heroku config:add NODE_ENV=demo01        --app anbu-presentation-demo01
	heroku config:add NODE_ENV=stage01       --app anbu-presentation-stage01
	heroku config:add NODE_ENV=prod01        --app anbu-presentation-prod01
	heroku config:add NODE_ENV=stub01        --app anbu-presentation-stub01
	heroku config:add APP_ENV=func01         --app anbu-core-func01
	heroku config:add APP_ENV=qa01           --app anbu-core-qa01
	heroku config:add APP_ENV=demo01         --app anbu-core-demo01
	heroku config:add APP_ENV=stage01        --app anbu-core-stage01
	heroku config:add APP_ENV=prod01         --app anbu-core-prod01
	heroku config:add APP_ENV=stub01         --app anbu-core-stub01

setup-travis:
	cd presentation && travis encrypt $(heroku auth:token) --add deploy.api_key --skip-version-check && git add -A && git commit -m "@thyms updated heroku deployment key."
	cd presentation-stubulator && travis encrypt $(heroku auth:token) --add deploy.api_key --skip-version-check && git add -A && git commit -m "@thyms updated heroku deployment key."
	cd core && travis encrypt $(heroku auth:token) --add deploy.api_key --skip-version-check && git add -A && git commit -m "@thyms updated heroku deployment key."
	cd core-stubulator && travis encrypt $(heroku auth:token) --add deploy.api_key --skip-version-check && git add -A && git commit -m "@thyms updated heroku deployment key."
	git add -A && git commit -m "@thyms updated heroku deployment key."
	rake project:push

test-app:
	echo 'No test to run for this project, try "make test-app-ci" for CI testing.'

test-app-ci:
	cd presentation-functional && make test-app-ci
	cd core-functional && make test-app-ci

ide-idea-clean:
	rm -rf *iml
	rm -rf .idea*

.PHONY: no_targets__ list
no_targets__:
list:
	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | sort"
