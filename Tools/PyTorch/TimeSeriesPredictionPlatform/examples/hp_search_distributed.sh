/# Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# More info here: https://hydra.cc/docs/plugins/optuna_sweeper/
python launch_training.py \
	-m \
	'model.config.n_head=choice(1,2,4)' \
    'trainer.optimizer.lr=tag(log, interval(1e-5, 1e-2))' \
	model=tft \
	dataset=electricity            \
	trainer/criterion=quantile     \
	trainer.config.batch_size=1024 \
	trainer.config.num_epochs=2    \
    trainer.config.log_interval=100 \
	+optuna_objectives=[P50]       \
	hydra/sweeper=optuna           \
	hydra.sweeper.n_trials=4      \
	hydra.sweeper.n_jobs=1         \
	hydra/launcher=torchrun
