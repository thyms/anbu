# type 'make -s list' to see list of targets.

checkout-project:
	git checkout develop
	git submodule update --init --recursive
	cd presentation && git remote rm origin && git remote add origin git@github.com:thyms/anbu-presentation.git && git fetch && git checkout develop
	cd presentation-functional && git remote rm origin && git remote add origin git@github.com:thyms/anbu-presentation-functional.git && git fetch && git checkout develop
	cd presentation-stubulator && git remote rm origin && git remote add origin git@github.com:thyms/anbu-presentation-stubulator.git && git fetch && git checkout develop
	cd core && git remote rm origin && git remote add origin git@github.com:thyms/anbu-core.git && git fetch && git checkout develop
	cd core-functional && git remote rm origin && git remote add origin git@github.com:thyms/anbu-core-functional.git && git fetch && git checkout develop
	cd core-stubulator && git remote rm origin && git remote add origin git@github.com:thyms/anbu-core-stubulator.git && git fetch && git checkout develop

setup-project:
	make checkout-project
	cd presentation && make setup-app
	cd presentation-stubulator && make setup-app
	cd core && make setup-app
	cd core-stubulator && make setup-app

setup-git:
	git remote rm origin && git remote add origin git@github-FILMSTER.com:thyms/anbu.git && git fetch && git checkout develop
	cd presentation && git remote rm origin && git remote add origin git@github-FILMSTER.com:thyms/anbu-presentation.git && git fetch && git checkout develop
	cd presentation-functional && git remote rm origin && git remote add origin git@github-FILMSTER.com:thyms/anbu-presentation-functional.git && git fetch && git checkout develop
	cd presentation-stubulator && git remote rm origin && git remote add origin git@github-FILMSTER.com:thyms/anbu-presentation-stubulator.git && git fetch && git checkout develop
	cd core && git remote rm origin && git remote add origin git@github-FILMSTER.com:thyms/anbu-core.git && git fetch && git checkout develop
	cd core-functional && git remote rm origin && git remote add origin git@github-FILMSTER.com:thyms/anbu-core-functional.git && git fetch && git checkout develop
	cd core-stubulator && git remote rm origin && git remote add origin git@github-FILMSTER.com:thyms/anbu-core-stubulator.git && git fetch && git checkout develop

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
