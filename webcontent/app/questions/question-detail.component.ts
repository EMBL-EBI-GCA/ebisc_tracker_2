import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from'@angular/router';
import { Subscription } from 'rxjs/Subscription';

import { Exam } from '../common/exam';
import { RouteExamService } from '../common/services/route-exam.service';
import { RouteDateService } from '../common/services/route-date.service';

@Component({
    templateUrl: './question-detail.component.html'
})
export class QuestionDetailComponent implements OnInit, OnDestroy{

  // public properties
  questionModule: string = null;
  date: string = null;
  exam: Exam;

  // private properties
  private examSubscription: Subscription = null;
  private dateSubscription: Subscription = null;
  
  constructor(
    private activatedRoute: ActivatedRoute,
    private routeExamService: RouteExamService,
    private routeDateService: RouteDateService,
  ){};

  ngOnInit() {
    this.examSubscription =
      this.routeExamService.exam$.subscribe((exam:Exam) => this.exam = exam);
    this.dateSubscription =
      this.routeDateService.date$.subscribe((date:string) => {
        this.questionModule = this.activatedRoute.snapshot.params['qModule'];
        this.date = date;
      });
  };

  ngOnDestroy() {
    if (this.examSubscription) {
      this.examSubscription.unsubscribe();
    }
    if (this.dateSubscription) {
      this.dateSubscription.unsubscribe();
    }
  }
};
