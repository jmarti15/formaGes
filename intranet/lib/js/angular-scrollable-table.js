(function (angular) {
  'use strict';
  angular.module('scrollable-table', [])
    .directive('scrollableTable', ['$timeout', '$q', '$parse', function ($timeout, $q, $parse) {
      return {
        transclude: true,
        restrict: 'E',
        scope: {
          rows: '=watch',
          sortFn: '='
        },
        template: '<div class="scrollableContainer">' +
                    '<div class="headerSpacer"></div>' +
                    '<div class="scrollArea" ng-transclude></div>' +
                  '</div>',
        controller: ['$scope', '$element', '$attrs', function ($scope, $element, $attrs) {
          // define an API for child directives to view and modify sorting parameters
          this.getSortExpr = function () {
            return $scope.sortExpr;
          };
          this.isAsc = function () {
            return $scope.asc;
          };
          this.setSortExpr = function (exp) {
            $scope.asc = true;
            $scope.sortExpr = exp;
          };
          this.toggleSort = function () {
            $scope.asc = !$scope.asc;
          };

          this.doSort = function (comparatorFn) {
            if (comparatorFn) {
              $scope.rows.sort(function (r1, r2) {
                var compared = comparatorFn(r1, r2);
                return $scope.asc ? compared : compared * -1;
              });
            } else {
              $scope.rows.sort(function (r1, r2) {
                var compared = defaultCompare(r1, r2);
                return $scope.asc ? compared : compared * -1;
              });
            }
          };

          this.renderTalble = function (){
            return waitForRender().then(fixHeaderWidths);
          };

          this.getTableElement = function (){
            return $element;
          };

          /**
           * append handle function to execute after table header resize.
           */
          this.appendTableResizingHandler = function (handler){
            var handlerSequence = $scope.headerResizeHanlers || [];
            for(var i = 0;i < handlerSequence.length;i++){
              if(handlerSequence[i].name === handler.name){
                return;
              }
            }
            handlerSequence.push(handler);
            $scope.headerResizeHanlers = handlerSequence;
          };

          function defaultCompare(row1, row2) {
            var exprParts = $scope.sortExpr.match(/(.+)\s+as\s+(.+)/);
            var scope = {};
            scope[exprParts[1]] = row1;
            var x = $parse(exprParts[2])(scope);

            scope[exprParts[1]] = row2;
            var y = $parse(exprParts[2])(scope);

            if (x === y) return 0;
            return x > y ? 1 : -1;
          }

          function scrollToRow(row) {
            var offset = $element.find(".headerSpacer").height();
            var currentScrollTop = $element.find(".scrollArea").scrollTop();
            $element.find(".scrollArea").scrollTop(currentScrollTop + row.position().top - offset);
          }

          $scope.$on('rowSelected', function (event, rowId) {
            var row = $element.find(".scrollArea table tr[row-id='" + rowId + "']");
            if (row.length === 1) {
              // Ensure that the headers have been fixed before scrolling, to ensure accurate
              // position calculations
              $q.all([waitForRender(), headersAreFixed.promise]).then(function () {
                scrollToRow(row);
              });
            }
          });

          // Set fixed widths for the table headers in case the text overflows.
          // There's no callback for when rendering is complete, so check the visibility of the table
          // periodically -- see http://stackoverflow.com/questions/11125078
          function waitForRender() {
            var deferredRender = $q.defer();
            function wait() {
              if ($element.find("table:visible").length === 0) {
                $timeout(wait, 100);
              } else {
                deferredRender.resolve();
              }
            }

            $timeout(wait);
            return deferredRender.promise;
          }

          var headersAreFixed = $q.defer();

          function fixHeaderWidths() {
            if (!$element.find("thead th .th-inner").length) {
              $element.find("thead th").wrapInner('<div class="th-inner"></div>');
            }
            if($element.find("thead th .th-inner:not(:has(.box))").length) {
              $element.find("thead th .th-inner:not(:has(.box))").wrapInner('<div class="box"></div>');
            }

            $element.find("table th .th-inner:visible").each(function (index, el) {
              el = angular.element(el);
              var width = el.parent().width(),
                lastCol = $element.find("table th:visible:last"),
                headerWidth = width;
              if (lastCol.css("text-align") !== "center") {
                var hasScrollbar = $element.find(".scrollArea").height() < $element.find("table").height();
                if (lastCol[0] == el.parent()[0] && hasScrollbar) {
                  headerWidth += $element.find(".scrollArea").width() - $element.find("tbody tr").width();
                  headerWidth = Math.max(headerWidth, width);
                }
              }
              var minWidth = _getScale(el.parent().css('min-width')),
                title = el.parent().attr("title");
              headerWidth = Math.max(minWidth, headerWidth);
              el.css("width", headerWidth);
              if (!title) {
                // ordinary column(not sortableHeader) has box child div element that contained title string.
                title = el.find(".title .ng-scope").html() || el.find(".box").html();
              }
              el.attr("title", title.trim());
            });
            headersAreFixed.resolve();
          }

          // when the data model changes, fix the header widths.  See the comments here:
          // http://docs.angularjs.org/api/ng.$timeout
          $scope.$watch('rows', function (newValue, oldValue) {
            if (newValue) {
              renderChains($element.find('.scrollArea').width());
              // clean sort status and scroll to top of table once records replaced.
              $scope.sortExpr = null;
              // FIXME what is the reason here must scroll to top? This may cause confusing if using scrolling to implement pagination.
              $element.find('.scrollArea').scrollTop(0);
            }
          });

          $scope.asc = !$attrs.hasOwnProperty("desc");
          $scope.sortAttr = $attrs.sortAttr;

          $element.find(".scrollArea").scroll(function (event) {
            $element.find("thead th .th-inner").css('margin-left', 0 - event.target.scrollLeft);
          });

          $scope.$on("renderScrollableTable", function() {
            renderChains($element.find('.scrollArea').width());
          });

          angular.element(window).on('resize', function(){
            $scope.$apply();
          });
          $scope.$watch(function(){
            return $element.find('.scrollArea').width();
          }, function(newWidth, oldWidth){
            if(newWidth * oldWidth <= 0){
              return;
            }
            renderChains();
          });

          function renderChains(){
            var resizeQueue = waitForRender().then(fixHeaderWidths),
              customHandlers = $scope.headerResizeHanlers || [];
            for(var i = 0;i < customHandlers.length;i++){
              resizeQueue = resizeQueue.then(customHandlers[i]);
            }
            return resizeQueue;
          }
        }]
      };
    }])
    .directive('sortableHeader', [function () {
      return {
        transclude: true,
        scope: true,
        require: '^scrollableTable',
        template:
          '<div class="box">' +
            '<div ng-mouseenter="enter()" ng-mouseleave="leave()">' +
              '<div class="title" ng-transclude></div>' +
              '<span class="orderWrapper">' +
                '<span class="order" ng-show="focused || isActive()" ng-click="toggleSort($event)" ng-class="{active:isActive()}">' +
                  '<i ng-show="isAscending()" class="glyphicon glyphicon-chevron-up"></i>' +
                  '<i ng-show="!isAscending()" class="glyphicon glyphicon-chevron-down"></i>' +
                '</span>' +
              '</span>' +
            '</div>' +
          '</div>',
        link: function (scope, elm, attrs, tableController) {
          var expr = attrs.on || "a as a." + attrs.col;
          scope.element = angular.element(elm);
          scope.isActive = function () {
            return tableController.getSortExpr() === expr;
          };
          scope.toggleSort = function (e) {
            if (scope.isActive()) {
              tableController.toggleSort();
            } else {
              tableController.setSortExpr(expr);
            }
            tableController.doSort(scope[attrs.comparatorFn]);
            e.preventDefault();
          };
          scope.isAscending = function () {
            if (scope.focused && !scope.isActive()) {
              return true;
            } else {
              return tableController.isAsc();
            }
          };

          scope.enter = function () {
            scope.focused = true;
          };
          scope.leave = function () {
            scope.focused = false;
          };

          scope.isLastCol = function() {
            return elm.parent().find("th:last-child").get(0) === elm.get(0);
          };
        }
      };
    }]);

  function _getScale(sizeCss){
    return parseInt(sizeCss.replace(/px|%/, ''), 10);
  }
})(angular);
