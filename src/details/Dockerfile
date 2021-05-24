# Copyright Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM ruby:2.7.1

COPY Gemfile* /opt/microservices/
COPY *.rb /opt/microservices/
COPY config /opt/microservices/config

COPY appdynamics-cpp-sdk /opt/appdynamics-cpp-sdk
ENV LD_LIBRARY_PATH /opt/appdynamics-cpp-sdk:/opt/appdynamics-cpp-sdk/lib:$LD_LIBRARY_PATH

RUN gem install activesupport appdynamics sinatra

ARG service_version
ENV SERVICE_VERSION ${service_version:-v1}

ARG enable_external_book_service
ENV ENABLE_EXTERNAL_BOOK_SERVICE ${enable_external_book_service:-false}

EXPOSE 9080
WORKDIR /opt/microservices

CMD ["ruby", "main.rb"]
