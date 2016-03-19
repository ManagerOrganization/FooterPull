Mock Page Fetcher
============
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic&label=Legal)](https://raw.githubusercontent.com/rob-nash/InfiniteScroll/master/Licence.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-Greene.svg?style=plastic)](https://github.com/Carthage/Carthage)

##Description
<sup>XCode 6.4+ iOS 8.0+</sup>

Useful for simulating network requests for mock data. Can be configured to page data and wait x number of seconds before returning a page.

## Installation with Carthage
Add the following to your Cartfile. See [Carthage](https://github.com/Carthage/Carthage) for details.

* github "https://github.com/rob-nash/MockPageFetcher" >= 1.0.0

## Usage

```objective-c
__weak typeof(self) weakSelf = self;

[self.fetcher fetchFreshDataWithFetchDuration:2
                               withCompletion:^(BOOL dataFound) {

                                   __strong typeof (weakSelf) strongSelf = weakSelf;

                                   if (dataFound) {
                                       [strongSelf.tableView reloadData];
                                   }

                                   //strongSelf stop loading spinner

                               }];

[self.fetcher fetchNextPageWithFetchDuration:2
                                 withCompletion:^(BOOL nextPageFound) {
                                     
                                     __strong typeof (weakSelf) strongSelf = weakSelf;

                                     if (nextPageFound) {
                                       [strongSelf.tableView reloadData];
                                   }

                                     //strongSelf stop loading spinner

                                 }];
```
