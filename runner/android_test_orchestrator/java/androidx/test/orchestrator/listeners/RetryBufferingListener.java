/*
 * Copyright (C) 2025 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package androidx.test.orchestrator.listeners;

import android.app.Instrumentation;
import androidx.test.orchestrator.junit.ParcelableDescription;
import androidx.test.orchestrator.junit.ParcelableFailure;
import androidx.test.orchestrator.junit.ParcelableResult;
import java.util.ArrayList;
import java.util.List;

/**
 * Holds back the events of the current test attempt so that attempts which are retried are never
 * reported: only the final attempt of each test reaches the delegates.
 */
public final class RetryBufferingListener extends OrchestrationRunListener {

  private interface Event {
    void dispatch(OrchestrationRunListener listener);
  }

  private final List<OrchestrationRunListener> delegates;
  private final List<Event> pending = new ArrayList<>();
  private boolean failed;

  public RetryBufferingListener(List<OrchestrationRunListener> delegates) {
    this.delegates = new ArrayList<>(delegates);
  }

  /** Whether the buffered attempt reported a failure. */
  public synchronized boolean hasFailure() {
    return failed;
  }

  /** Reports the buffered attempt to the delegates. */
  public synchronized void flush() {
    for (Event event : pending) {
      for (OrchestrationRunListener delegate : delegates) {
        event.dispatch(delegate);
      }
    }
    pending.clear();
    failed = false;
  }

  /** Drops the buffered attempt because it is going to be retried. */
  public synchronized void discard() {
    pending.clear();
    failed = false;
  }

  private synchronized void buffer(Event event) {
    pending.add(event);
  }

  @Override
  public void setInstrumentation(Instrumentation instrumentation) {
    super.setInstrumentation(instrumentation);
    for (OrchestrationRunListener delegate : delegates) {
      delegate.setInstrumentation(instrumentation);
    }
  }

  @Override
  public void orchestrationRunStarted(int testCount) {
    for (OrchestrationRunListener delegate : delegates) {
      delegate.orchestrationRunStarted(testCount);
    }
  }

  @Override
  public void testRunStarted(ParcelableDescription description) {
    buffer(listener -> listener.testRunStarted(description));
  }

  @Override
  public void testStarted(ParcelableDescription description) {
    buffer(listener -> listener.testStarted(description));
  }

  @Override
  public void testFinished(ParcelableDescription description) {
    buffer(listener -> listener.testFinished(description));
  }

  @Override
  public synchronized void testFailure(ParcelableFailure failure) {
    failed = true;
    buffer(listener -> listener.testFailure(failure));
  }

  @Override
  public void testAssumptionFailure(ParcelableFailure failure) {
    buffer(listener -> listener.testAssumptionFailure(failure));
  }

  @Override
  public void testIgnored(ParcelableDescription description) {
    buffer(listener -> listener.testIgnored(description));
  }

  @Override
  public void testRunFinished(ParcelableResult result) {
    buffer(listener -> listener.testRunFinished(result));
  }

  @Override
  public void testProcessFinished(String message) {
    buffer(listener -> listener.testProcessFinished(message));
  }
}
