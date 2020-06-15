## Guide
If you don't see your idea listed, and you think it fits into the goals of this library, do the following:

0. Find an issue that you are interested in addressing or a feature that you would like to add.
0. Fork the repository associated with the issue to your local GitHub organization. This means that you will have a copy of the repository under `your-GitHub-username/repository-name`.
0. Clone the repository to your local machine using `git clone https://github.com/beamkenya/at_sample_app.git`
0. Create a new branch for your fix using `git checkout -b your-branch-name-here`.
0. Make the appropriate changes for the issue you are trying to address or the feature that you want to add.
0. Use `git add insert-paths-of-changed-files-here` to add the file contents of the changed files to the "snapshot" git uses to manage the state of the project, also known as the index.
0. Use `git commit -m "Insert a short message of the changes made here"` to store the contents of the index with a descriptive message.
0. Push the changes to the remote repository using `git push origin your-branch-name-here`.
0. Submit a pull request to the upstream repository.
0. Title the pull request with a short description of the changes made and the issue or bug number associated with your change. For example, you can title an issue like so "Added more log outputting to resolve #4352".
0.In the description of the pull request, explain the changes that you made, any issues you think exist with the pull request you made, and any questions you have for the maintainers. It's OK if your pull request is not perfect (no pull request is), the reviewer will be able to help you fix any problems and improve it!
0. Wait for the pull request to be reviewed by a maintainer.
0. Make changes to the pull request if the reviewing maintainer recommends them.
0. Celebrate your success after your pull request is merged!

## Style guide
Ensure you run `mix format` to format the code to the best standards and limit failure when the CI runs.